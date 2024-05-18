import numpy as np
import trimesh
import pandas as pd
from scipy.interpolate import Rbf
import logging
import time
import os
import pyvista as pv  # PyVista for 3D visualization

# Setup logging configuration
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def load_landmarks_from_excel(excel_path):
    df = pd.read_excel(excel_path)
    landmarks = df.filter(regex='^[xyz][0-9]+').values.reshape(-1, 90, 3)
    sexes = df['Sex'].values
    logging.info("Landmarks and sexes loaded from Excel successfully.")
    return landmarks, sexes

def generalized_procrustes_analysis(landmarks, sexes):
    female_landmarks = landmarks[sexes == 1]
    male_landmarks = landmarks[sexes == 2]
    average_female = np.mean(female_landmarks, axis=0)
    average_male = np.mean(male_landmarks, axis=0)
    logging.info("Generalized Procrustes Analysis completed successfully.")
    return average_female, average_male

def apply_rbf_warp(mesh, source_landmarks, target_landmarks):
    logging.info("Starting RBF warping...")
    interpolator_x = Rbf(source_landmarks[:, 0], source_landmarks[:, 1], source_landmarks[:, 2], target_landmarks[:, 0], function='thin_plate')
    interpolator_y = Rbf(source_landmarks[:, 0], source_landmarks[:, 1], source_landmarks[:, 2], target_landmarks[:, 1], function='thin_plate')
    interpolator_z = Rbf(source_landmarks[:, 0], source_landmarks[:, 1], source_landmarks[:, 2], target_landmarks[:, 2], function='thin_plate')

    deformed_vertices = np.vstack((
        interpolator_x(mesh.vertices[:, 0], mesh.vertices[:, 1], mesh.vertices[:, 2]),
        interpolator_y(mesh.vertices[:, 0], mesh.vertices[:, 1], mesh.vertices[:, 2]),
        interpolator_z(mesh.vertices[:, 0], mesh.vertices[:, 1], mesh.vertices[:, 2])
    )).T

    deformed_mesh = trimesh.Trimesh(vertices=deformed_vertices, faces=mesh.faces)
    logging.info("RBF warping completed successfully.")
    return deformed_mesh

def save_mesh(mesh, filename):
    try:
        mesh.export(filename)
        logging.info(f"Mesh saved successfully as {filename}.")
    except Exception as e:
        logging.error(f"Failed to save mesh {filename}: {e}")

def create_heatmap(base_mesh, modified_mesh, title):
    displacement = np.linalg.norm(modified_mesh.points - base_mesh.points, axis=1)
    heatmap_mesh = pv.wrap(modified_mesh.copy())
    heatmap_mesh['displacement'] = displacement
    
    plotter = pv.Plotter()
    plotter.add_mesh(heatmap_mesh, scalars='displacement', cmap='RdYlGn_r', stitle="Vertex Displacement", clim=[displacement.min(), displacement.max()])
    plotter.add_text(title, font_size=24)
    plotter.show()

# Main script execution
excel_path = 'Exported_Symmetry_Coords_notGPA.xlsx'
female_mesh_path = 'PT_0000496_F.stl'
male_mesh_path = 'Pan_troglodytes_AS_1810_M_AIMZ_pelvis_223kp.stl'

landmarks, sexes = load_landmarks_from_excel(excel_path)
average_female_landmarks, average_male_landmarks = generalized_procrustes_analysis(landmarks, sexes)

# Calculate the exaggerated differences
difference_vector = average_female_landmarks - average_male_landmarks
exaggerated_difference_vector = difference_vector * 1.3
exaggerated_female_landmarks = average_female_landmarks + exaggerated_difference_vector
exaggerated_male_landmarks = average_male_landmarks - exaggerated_difference_vector

# Load meshes and apply warping
female_mesh = trimesh.load(female_mesh_path)
male_mesh = trimesh.load(male_mesh_path)
hyper_female_mesh = apply_rbf_warp(female_mesh, average_female_landmarks, exaggerated_female_landmarks)
hyper_male_mesh = apply_rbf_warp(male_mesh, average_male_landmarks, exaggerated_male_landmarks)

# Save average landmarks as meshes
average_female_mesh = apply_rbf_warp(female_mesh, average_female_landmarks, average_female_landmarks)
average_male_mesh = apply_rbf_warp(male_mesh, average_male_landmarks, average_male_landmarks)
save_mesh(average_female_mesh, 'average_female_mesh.stl')
save_mesh(average_male_mesh, 'average_male_mesh.stl')

# Save warped meshes
save_mesh(hyper_female_mesh, 'hyper_female_mesh.stl')
save_mesh(hyper_male_mesh, 'hyper_male_mesh.stl')

# Convert Trimesh objects to PyVista meshes for visualization
average_female_mesh_pv = pv.wrap(average_female_mesh)
hyper_female_mesh_pv = pv.wrap(hyper_female_mesh)
average_male_mesh_pv = pv.wrap(average_male_mesh)
hyper_male_mesh_pv = pv.wrap(hyper_male_mesh)

# Create and show heatmaps
create_heatmap(average_female_mesh_pv, hyper_female_mesh_pv, "Female Average to Hyper-Female Heatmap")
create_heatmap(average_male_mesh_pv, hyper_male_mesh_pv, "Male Average to Hyper-Male Heatmap")
