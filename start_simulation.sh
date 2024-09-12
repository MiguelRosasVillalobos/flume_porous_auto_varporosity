#!/bin/bash
#Miguel Rosas

# Lista de valores para lc
valores_a=("0.3" "1.8" "0.429" "1.1775")

# Verifica si se proporciona la cantidad como argumento
if [ $# -eq 0 ]; then
  echo "Uso: $0 cantidad"
  exit 1
fi

# Obtiene la cantidad desde el primer argumento
cantidad=$1

# Bucle para crear y mover carpetas, editar y genrar mallado
for ((i = 1; i <= $cantidad; i++)); do
  # Genera el nombre de la carpeta
  nombre_carpeta="Case_$i"

  # Crea la carpeta del caso
  mkdir "$nombre_carpeta"

  # Copia carpetas del caso dentro de las carpetasgeneradas
  cp -r "Case_0/0/" "$nombre_carpeta/"
  cp -r "Case_0/0.orig/" "$nombre_carpeta/"
  cp -r "Case_0/constant/" "$nombre_carpeta/"
  cp -r "Case_0/system/" "$nombre_carpeta/"
  cp "Case_0/extract_freesurface_plane.py" "$nombre_carpeta/"
  cp "Case_0/extract_freesurface.sh" "$nombre_carpeta/"
  cp "Case_0/extractor.py" "$nombre_carpeta/"

  # Copia un archivo dentro de la carpeta
  archivo_geo="Case_0/flume.geo"
  archivo_geoi="flume_Case_$i.geo"
  touch "$archivo_geo"
  cp "$archivo_geo" "$nombre_carpeta/$archivo_geoi"

  # Realiza el intercambio en el archivo
  valor_a="${valores_a[i - 1]}"
  sed -i "s/\$aa/$valor_a/g" "$nombre_carpeta/system/setFieldsDict"
  sed -i "s/\$aa/$valor_a/g" "$nombre_carpeta/system/topoSetDict"
  sed -i "s/\$aa/$valor_a/g" "$nombre_carpeta/extractor.py"
  sed -i "s/\$i/$i/g" "$nombre_carpeta/extract_freesurface_plane.py"
  sed -i "s/\$i/$i/g" "$nombre_carpeta/extractor.py"

  #Generar mallado gmsh
  cd "$nombre_carpeta/"
  gmsh "$archivo_geoi" -3

  #Genera mallado OpenFoam
  gmshToFoam "flume_Case_$i.msh"

  #Lineas a eliminar en polymesh/bondary
  lineas_eliminar=("24" "30" "36" "42" "48" "54")

  #Itera sobre las líneas a eliminar y utiliza sed para quitarlas
  for numero_linea in "${lineas_eliminar[@]}"; do
    sed -i "${numero_linea}d" "constant/polyMesh/boundary"
  done

  # Reemplaza "patch" por "wall"
  sed -i '29s/patch/wall/; 35s/patch/wall/ ' "constant/polyMesh/boundary"
  sed -i '23s/patch/empty/ ' "constant/polyMesh/boundary"
  # topoSet
  setFields >lof
  decomposePar
  mpirun -np 8 interIsoFoam -parallel >log
  # ./extract_freesurface.sh
  # python3 extractor.py
  # rm -r ./proce*
  cd ..
done

echo "Proceso completado."
