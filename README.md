# Mini-UnionFS

A lightweight userspace implementation of a **Union File System (UnionFS)** using **FUSE3 (Filesystem in Userspace)**. The project combines a read-only lower filesystem layer and a read-write upper filesystem layer to provide a unified virtual filesystem view.

The implementation demonstrates core filesystem concepts including **layer stacking, Copy-on-Write (CoW), whiteout files, path resolution, and POSIX filesystem operations**.

---

## Overview

Mini-UnionFS creates a virtual mount point that merges two directory layers:

* **Lower Layer**: Read-only base filesystem containing original files.
* **Upper Layer**: Read-write layer storing modifications and new files.

When a file exists in both layers, the upper layer takes priority. Modifications to lower-layer files trigger a Copy-on-Write mechanism, allowing changes without modifying the original base layer.

---

## Features

### Layered Filesystem View

* Combines lower and upper directories into a single mount point.
* Provides transparent access to files from both layers.
* Upper layer overrides lower layer content.

### Copy-on-Write Mechanism

* Automatically copies lower-layer files into the upper layer before modification.
* Preserves the original read-only filesystem.
* Enables container-style filesystem behavior.

### Whiteout File Support

* Implements deletion of lower-layer files using whiteout markers.
* Creates `.wh.<filename>` entries in the upper layer to hide deleted files.

### POSIX Filesystem Operations

Supports common filesystem operations:

* File attribute retrieval (`getattr`)
* Directory listing (`readdir`)
* File reading and writing
* File creation
* File deletion
* Directory creation and removal
* File truncation
* Permission modification
* Timestamp updates

### Web Dashboard

* Includes a Flask-based UI for monitoring and interacting with the filesystem.
* Provides a simple interface for observing filesystem state.

---

## System Architecture

```
                 User Applications
                         |
                         |
                  Virtual Mount Point
                         |
                         |
                  Mini-UnionFS (FUSE3)
                         |
              -------------------------
              |                       |
        Upper Layer              Lower Layer
      (Read/Write)             (Read Only)
              |
              |
       Copy-on-Write Storage
```

---

## Technologies Used

### Programming Language

* C

### Filesystem Framework

* FUSE3 (Filesystem in Userspace)

### Build System

* GNU Make

### Web Interface

* Python
* Flask

### Operating System

* Linux

---

## Project Structure

```
mini-unionfs/
│
├── main.c                  # FUSE initialization and operation registration
├── fs_state.h              # Shared filesystem state definitions
│
├── path_utils.c/h          # Path resolution and layer lookup logic
├── getattr.c               # File attribute handling
├── readdir.c               # Directory listing implementation
├── read_write.c            # Read, write and file modification operations
├── cow.c                   # Copy-on-Write implementation
├── unlink_whiteout.c       # Whiteout deletion mechanism
├── mkdir_rmdir.c           # Directory operations
│
├── test_unionfs.sh         # Automated filesystem test suite
├── Makefile                # Build configuration
│
└── ui/
    ├── server.py           # Flask dashboard backend
    ├── requirements.txt
    └── static/
        └── index.html
```

---

## Installation Requirements

Install required dependencies:

```bash
sudo apt update
sudo apt install -y build-essential libfuse3-dev pkg-config
```

For the web dashboard:

```bash
pip3 install flask
```

---

## Building the Project

Clone the repository:

```bash
git clone <repository-url>
cd mini-unionfs
```

Compile the filesystem:

```bash
make
```

This generates the executable:

```
./mini_unionfs
```

---

## Running Mini-UnionFS

### 1. Create filesystem layers

```bash
mkdir -p lower upper mnt
```

### 2. Add files to the lower layer

Example:

```bash
echo "Hello from lower layer" > lower/sample.txt
```

### 3. Mount the filesystem

```bash
./mini_unionfs lower upper mnt
```

### 4. Access the unified filesystem

```bash
ls mnt
cat mnt/sample.txt
```

### 5. Unmount

```bash
fusermount3 -u mnt
```

---

## Testing

The project includes an automated test suite covering filesystem functionality.

Run:

```bash
chmod +x test_unionfs.sh
bash test_unionfs.sh
```

The test suite validates:

* File visibility across layers
* Copy-on-Write behavior
* File creation
* File deletion using whiteouts
* Directory operations
* Read/write functionality

---

## Key Concepts Demonstrated

This project provides practical implementation of:

* Virtual filesystems
* FUSE architecture
* Filesystem layering
* Container storage concepts
* Copy-on-Write storage models
* Whiteout file mechanisms
* Linux filesystem operations

---

## Applications

Concepts implemented in this project are similar to those used in:

* Container storage drivers
* Docker overlay filesystems
* Snapshot-based storage systems
* Virtual machine storage layers

---

## Contributors

Developed as an academic project demonstrating operating system and filesystem concepts.

---

## License

This project is developed for educational purposes.
