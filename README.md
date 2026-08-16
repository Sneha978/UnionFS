# Mini-UnionFS

A simplified Union File System implemented in userspace using FUSE3 (libfuse3).  
It merges a **read-only lower directory** (base image layer) and a **read-write upper directory** (container layer) into a single virtual mount point.

## Team Members

| Name              | USN            |
|-------------------|----------------|
| Sirisha Veluvolu  | PES2UG23CS583  |
| Sneha J           | PES2UG23CS585  |
| Sneha Shetty      | PES2UG23CS587  |
| Sowmya Hardageri  | PES2UG23CS590  |

---

## Features

- **Layer Stacking** – merged view of lower + upper directories; upper takes precedence.
- **Copy-on-Write (CoW)** – modifying a lower-only file copies it to upper first.
- **Whiteout** – deleting a lower-only file creates `.wh.<name>` in upper to hide it.
- **Full POSIX ops** – `getattr`, `readdir`, `read`, `write`, `create`, `unlink`, `mkdir`, `rmdir`, `truncate`, `chmod`, `utimens`.

---

## Prerequisites

```bash
sudo apt update
sudo apt install -y build-essential libfuse3-dev pkg-config
```

---

## Build

```bash
make
```

This produces the `./mini_unionfs` binary.

---

## Usage

```bash
# 1. Create the three directories
mkdir -p lower upper mnt

# 2. Populate the base (lower) layer
echo "hello from base" > lower/hello.txt

# 3. Mount
./mini_unionfs lower upper mnt &

# 4. Interact with the unified view
ls mnt/
cat mnt/hello.txt

# 5. Unmount when done
fusermount3 -u mnt
```

---

## Running the Test Suite

```bash
chmod +x test_unionfs.sh
bash test_unionfs.sh
```

The script creates its own isolated `unionfs_test_env/` directory, runs 7 tests, and cleans up after itself.

---

## Project Structure

```
mini-unionfs/
├── main.c              # Entry point — fuse_operations struct + main()
├── fs_state.h          # Shared state struct, macros, inline path helpers
├── path_utils.c/h      # Path resolution (whiteout check → upper → lower)
├── getattr.c           # unionfs_getattr  (lstat on resolved path)
├── readdir.c           # unionfs_readdir  (merged listing, whiteout-aware)
├── read_write.c        # open / read / write / create / truncate / chmod / utimens
├── cow.c/h             # Copy-on-Write helper
├── unlink_whiteout.c   # unionfs_unlink   (physical delete + whiteout creation)
├── mkdir_rmdir.c       # unionfs_mkdir / unionfs_rmdir
├── Makefile
├── test_unionfs.sh
├── README.md
└── design_document.pdf
```

---

## Clean Up

```bash
make clean          # removes .o files, binary, and lower/upper/mnt dirs
```
