# Find all the main functions in the exercise_*.py files and make them available to the __all__ list
import os
import re
import importlib.util
import sys


def find_files_with_main_functions(directory):
    main_function_pattern = re.compile(r"def\s+main\s*\(.*\):")
    entry_point_pattern = re.compile(r'if\s+__name__\s*==\s*["\']__main__["\']\s*:')
    main_functions = []

    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith(".py"):
                file_path = os.path.join(root, file)
                with open(file_path, "r", encoding="utf-8") as f:
                    content = f.read()

                if main_function_pattern.search(content) and entry_point_pattern.search(
                    content
                ):
                    main_functions.append(file_path)

    return main_functions


def import_main_function_from_file(file_path):
    module_name = os.path.splitext(os.path.basename(file_path))[0]

    spec = importlib.util.spec_from_file_location(module_name, file_path)
    module = importlib.util.module_from_spec(spec)

    sys.modules[module_name] = module
    spec.loader.exec_module(module)

    # Rename main with EXERCISE number
    if hasattr(module, "main"):
        globals()[f"main_{module.EXERCISE}"] = module.main
    else:
        raise AttributeError(
            f"The module {module_name} does not have a 'main' function"
        )

    return f"main_{module.EXERCISE}"


__all__ = [
    import_main_function_from_file(file)
    for file in find_files_with_main_functions("adventofcode/exercises")
]
