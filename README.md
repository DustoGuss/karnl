# Karnl

**Karnl** is an open-source kernel primarily written in [Zig](https://ziglang.org/).  
It began as a personal project to learn more about low-level systems programming and to ~~suffer~~ have fun building a kernel from scratch.

---

## ✨ Features (so far)

- ✅ VGA text-mode output
- ✅ **VERY** basic keyboard I/O support
- 🚧 More features coming soon...

> ⚠️ **Note:**  
> Karnl is still in the very early stages of development — it currently doesn't have allocators, a filesystem, or much else… yet!

---

## 📦 Requirements

- [Zig](https://ziglang.org/) — tested with `0.14.0`+
- [QEMU](https://www.qemu.org/)
- A Unix-like environment (Linux, macOS, or WSL recommended)

> ⚠️ **Note:**  
> Currently, Karnl is best supported on Linux/Unix environments.  
> **Windows support is planned for upcoming updates** — or feel free to contribute if you'd like to help bring it earlier!

---

## ⚙️ Building

Clone the repo and run `build.sh`:

```bash
git clone https://github.com/DustoGuss/karnl.git
cd karnl
./build.sh # or chmod +x build.sh & ./build.sh
```

## 🧪 Inspirations & References

- [OSDev Wiki](https://wiki.osdev.org/)
- [Pluto](https://github.com/ZystemOS/pluto)

## 🛠️ License

Karnl is under the MIT License — so feel free to fork it, modify it, and build cool things with it.  
