import std.complex;
import std.stdio;
import std.conv;
import std.math;
import std.getopt;
import std.file;

void main(string[] args) {
    uint max = 1000;
    uint width  = 400;
    uint height = 400;
    double zoom = 1;
    ubyte aa = 1;
    double posR = 0;
    double posI = 0;

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
    imageData.length = width*height*3;
    foreach (y; 0 .. height) {
        foreach (x; 0 .. width) {
            double sumR = 0;
            double sumG = 0;
            double sumB = 0;

            foreach (xaa; 0 .. aa) {
                foreach (yaa; 0 .. aa) {
                    Complex!double c;
                    c.re = (x + double(xaa) / aa - width  / 2) / small * 4 / zoom + posR;
                    c.im = (y + double(yaa) / aa - height / 2) / small * 4 / zoom - posI;
                    Complex!double z = 0;

                    uint itr = 0;
                    for (; itr < max && z.re^^2 + z.im^^2 < 4; ++itr) {
                        z = z * z + c;
                    }

                    if (itr < max) {
                        sumR += (1 + cos(itr * PI / 100.0L + 1)) / 2 * 0xFF;
                        sumG += (1 + cos(itr * PI / 100.0L + 2)) / 2 * 0xFF;
                        sumB += (1 + cos(itr * PI / 100.0L + 3)) / 2 * 0xFF;
                    }
                }
            }

            imageData[(y * width + x) * 3 + 0] = cast(ubyte)(sumR / aa / aa);
            imageData[(y * width + x) * 3 + 1] = cast(ubyte)(sumG / aa / aa);
            imageData[(y * width + x) * 3 + 2] = cast(ubyte)(sumB / aa / aa);
        }

        writefln("Render: % 6.2f%% done", y.to!double / height * 100);
    }

    string filename = "mandelbrot " ~ to!string(width) ~ "x" ~ to!string(height) ~ " ";
    size_t n = 0;
    while (exists(filename ~ to!string(++n) ~ ".raw")) {}
    toFile(imageData, filename ~ to!string(n) ~ ".raw");
}
