import os

def rename_wav_files(root_dir):
    for folder, _, files in os.walk(root_dir):
        for file in files:
            if file.endswith(".PNG"):
                old_path = os.path.join(folder, file)
                new_path = os.path.join(folder, file[:-4] + ".png")
                os.rename(old_path, new_path)
                print(f"Renamed: {old_path} -> {new_path}")

if __name__ == "__main__":
    rename_wav_files("assets/")