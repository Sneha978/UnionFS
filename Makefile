CC      = gcc
CFLAGS  = -Wall -Wextra -g -Wno-format-truncation $(shell pkg-config fuse3 --cflags)
LDFLAGS = $(shell pkg-config fuse3 --libs)

TARGET  = mini_unionfs

SRCS    = main.c \
          path_utils.c \
          getattr.c \
          readdir.c \
          read_write.c \
          cow.c \
          unlink_whiteout.c \
          mkdir_rmdir.c

OBJS    = $(SRCS:.c=.o)

.PHONY: all clean mount umount test ui run

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f $(OBJS) $(TARGET)
	rm -rf lower upper mnt

dirs:
	mkdir -p lower upper mnt

umount:
	fusermount3 -u mnt 2>/dev/null || umount mnt 2>/dev/null || true

test: $(TARGET)
	bash test_unionfs.sh

ui: $(TARGET)
	@echo "Installing Flask..."
	pip3 install -q flask
	@echo "Starting dashboard at http://localhost:5000 ..."
	cd ui && python3 server.py

run: all ui
