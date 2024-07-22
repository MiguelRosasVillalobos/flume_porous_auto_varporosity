import pandas as pd
import numpy as np

a = $aa
# Cargar los archivos
file_paths = [
    "data2.csv",
    "data2.07549.csv",
    "data2.15098.csv"
]

# Extraer solo la segunda columna de cada archivo y usarla para formar un nuevo DataFrame con tres columnas
columns_from_each_file = [pd.read_csv(file_path, usecols=[1], header=None) for file_path in file_paths]

# Concatenar las columnas horizontalmente en lugar de verticalmente
combined_columns_horizontally = pd.concat(columns_from_each_file, axis=1)

# Guardar el resultado en un nuevo archivo
output_path_horizontal_columns = "freesurface_case$i.csv"
combined_columns_horizontally.to_csv(output_path_horizontal_columns, index=False)

# Cargar el archivo combinado
data = pd.read_csv("freesurface_case$i.csv")

# Eliminar las primeras dos filas
data_modified = data.iloc[2:]

# Guardar el archivo modificado
output_path_modified = "freesurface_case$i.csv"
data_modified.to_csv(output_path_modified, index=False)

# Cargar el archivo corregido
data_corrected = pd.read_csv("freesurface_case$i.csv")

# Guardar el archivo utilizando tabulaciones como delimitador en lugar de comas
output_path_tab_delimited = "freesurface_case$i.txt"
data_corrected.to_csv(output_path_tab_delimited, sep=' ', index=False)

# Cargar el archivo final previamente modificado
data_final_loaded = pd.read_csv("freesurface_case$i.txt", sep=' ')

# Crear una nueva columna con valores desde 0 hasta 90, usando un paso que se ajuste a la cantidad de filas
num_rows = data_final_loaded.shape[0]
step = 90 / num_rows
new_column = range(0, 90, int(step)) if step >= 1 else (step * i for i in range(num_rows))

# Añadir la nueva columna al DataFrame
data_final_loaded['New Column'] = list(new_column)[:num_rows]

# Guardar el archivo modificado
output_path_final_updated = "freesurface_case$i.txt"
data_final_loaded.to_csv(output_path_final_updated, sep=' ', index=False)


# Cargar los datos desde el archivo
data = np.loadtxt('freesurface_case$i.txt', skiprows=1)

# Restar 0.3 a las tres primeras columnas
data[:, :3] -= 0.3

# Guardar los datos modificados de vuelta al archivo
np.savetxt('freesurface_case$i.txt', data, fmt='%.6f')
