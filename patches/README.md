# Preserve original PNG density

`libcaesium-preserve-png-density.patch` targets libcaesium 0.17.4 (see
`libcaesium.conf`). CMake applies it automatically to the dependency checkout.
No extra fork or change to the C ABI is required.

With **Keep Metadata** enabled, PNG compression copies the original `pHYs`
chunk, including both axes and the unit byte, before resizing/quantization.
It restores that chunk after compression without decoding or recompressing
the output pixels. 300 PPI stays 300 PPI; other densities and unspecified
units are preserved exactly. Missing density stays missing. Metadata-disabled
compression keeps its existing behavior. This patch is specifically about
PNG density, not a promise to preserve all PNG metadata.

The file, preview and target-size entry points share the patched code. Density
is restored before target-size accounting. Original density is preserved even
when explicitly resizing; physical print dimensions therefore change with pixels.

Regression checks are included in the patch:

```
cargo test --lib ppi_tests
```

They cover 300 PPI, unequal axes, unspecified units, missing density, lossy and
lossless modes, resizing, file output, target-size compression, chunk ordering,
and byte-identical compressed image data with/without density restoration.

When updating libcaesium, rebase the patch and rerun these tests. The dependency
cache key includes the patch to avoid reusing an unpatched library.
