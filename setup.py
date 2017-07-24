from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize

extensions = [
    Extension("*", ["mysql/*.pyx"],
              libraries=["mysqlclient"])
]

setup(
    ext_modules=cythonize(extensions),
)
