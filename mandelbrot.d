import std.complex;
import std.stdio;
import std.conv;
import std.math;
import std.getopt;

void main(string[] args) {
    uint max = 1000;
    uint width  = 400;
    uint height = 400;
    real zoom = 1;
    ubyte aa = 1;
    real posR = 0;
    real posI = 0;

    getopt(args,
            "iterations|itr", &max,
            "width|w", &width,
            "height|h", &height,
            "zoom|z", &zoom,
            "aa|a", &aa,
            "x|r", &posR,
            "y|i", &posI);

    uint small  = (width < height) ? width : height;

    ubyte[] imageData;
    foreach (y; 0 .. height) {
        foreach (x; 0 .. width) {
            real sumR = 0;
            real sumG = 0;
            real sumB = 0;

            foreach (xaa; 0 .. aa) {
                foreach (yaa; 0 .. aa) {
                    Complex!real c;
                    c.re = (x + real(xaa) / aa - width  / 2) / small * 4 / zoom + posR;
                    c.im = (y + real(yaa) / aa - height / 2) / small * 4 / zoom + posI;
                    Complex!real z = 0;

                    uint i = 0;
                    for (; i < max && z.re * z.re + z.im * z.im < 4; ++i) {
                        z = z * z + c;
                    }

                    if (i != max) {
                        sumR += (1 + cos(i * PI / 110.0L)) / 2 * 0xFF;
                        sumG += (1 + cos(i * PI / 120.0L)) / 2 * 0xFF;
                        sumB += (1 + cos(i * PI / 130.0L)) / 2 * 0xFF;
                    }
                }
            }

            imageData ~= cast(ubyte)(sumR / aa / aa);
            imageData ~= cast(ubyte)(sumG / aa / aa);
            imageData ~= cast(ubyte)(sumB / aa / aa);
        }

        writeln("Render: ", y.to!real / height * 100, r"% done");
    }

    toFile(imageData, "mandelbrot.raw");
}
