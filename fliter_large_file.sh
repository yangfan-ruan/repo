find . -name "*.*" -size +100M | while read file; do
  git lfs track "$file"
done
