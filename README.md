# radare2-notebook
Jupyter notebook with Radare2


This docker is based on jupyter-notebook, and installs Radare2 next to it. 

Getting started:

```
docker run -p 8888:8888 -p 6006:6006 -v $(pwd)/notebooks/:/home/jovyan/ radare2-notebook 
```

The folder `notebooks` in current directory will be mounted on the Jupyter user folder in the container.

Now Jupyter is available at http://127.0.0.1:8888/.

