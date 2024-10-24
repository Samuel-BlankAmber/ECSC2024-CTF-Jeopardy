from distutils.core import setup, Extension


def main():
    setup(
        name="yap",
        version="1.0.0",
        description="Python interface for the yap C library function",
        author="Fabio Zoratti <orsobruno96>",
        author_email="fabio.zoratti96@gmail.com",
        ext_modules=[
            Extension(
                "yap", ["yapmodule.c"],
                extra_compile_args=["-fno-stack-protector", "-D_FORTIFY_SOURCE=0"]
            ),
        ]
    )


if __name__ == "__main__":
    main()
