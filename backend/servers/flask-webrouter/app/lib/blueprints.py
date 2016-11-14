import os
import sys

def register_blueprints(app, backend_path, server_path):
    # let s import automatically the python files that are on the shared backend
    # lib folder
    lib_path = os.path.join(backend_path, 'lib')
    if os.path.isdir(lib_path):
        sys.path.append(lib_path)
        shared_lib_names = map(
            lambda fcouples:
            fcouples[0],
            filter(
                lambda couples:
                couples[-1]=='py' and couples[0] != "__init__",
                map(
                    lambda file_name:
                    file_name.split('.'),
                    filter(
                        lambda dir_name:
                        dir_name[0] != ".",
                        os.listdir(lib_path)
                    )
                )
            )
        )
    else:
        shared_lib_names = []
    # then we can also go to specific modules inside this webserver
    modules_path = os.path.join(server_path, 'modules')
    if os.path.isdir(modules_path):
        sys.path.append(modules_path)
        module_names = map(
            lambda fcouples:
            fcouples[0],
            filter(
                lambda couples:
                couples[-1]=='py' and couples[0] != "__init__",
                map(
                    lambda file_name:
                    file_name.split('.'),
                    filter(
                        lambda dir_name:
                        dir_name[0] != ".",
                        os.listdir(modules_path)
                    )
                )
            )
        )
    else:
        module_names = []
    # and also it specific libs
    lib_path = os.path.join(server_path, 'lib')
    if os.path.isdir(lib_path):
        sys.path.append(lib_path)
        lib_names = map(
            lambda fcouples:
            fcouples[0],
            filter(
                lambda couples:
                couples[-1]=='py' and couples[0] != "__init__",
                map(
                    lambda file_name:
                    file_name.split('.'),
                    filter(
                        lambda dir_name:
                        dir_name[0] != ".",
                        os.listdir(lib_path)
                    )
                )
            )
        )
        for lib_name in lib_names:
            __import__(lib_name)
    # once the modules and libs are imported we can now
    # also plug the blueprints flask to the app
    map(
        lambda module:
        app.register_blueprint(getattr(module, module + '_blueprint')),
        filter(
            lambda module:
            hasattr(module,'blueprint'),
            map(
                lambda module_name:
                __import__(module_name),
                module_names
            )
        )
    )
