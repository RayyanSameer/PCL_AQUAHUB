import importlib
import sys
import os
import pytest


def reload_app_module():
    if 'backend.app' in sys.modules:
        del sys.modules['backend.app']
    # Ensure our project path is available when tests run locally
    return importlib.import_module('backend.app')


def test_missing_env_vars_causes_system_exit_in_production(monkeypatch):
    monkeypatch.setenv('FLASK_ENV', 'production')
    # unset one required var
    monkeypatch.delenv('DB_PASSWORD', raising=False)
    # ensure other required vars exist so only password is missing
    monkeypatch.setenv('DB_HOST', 'localhost')
    monkeypatch.setenv('DB_NAME', 'aquahub_db')
    monkeypatch.setenv('DB_USER', 'postgres')
    monkeypatch.setenv('DB_PORT', '5432')
    with pytest.raises(SystemExit):
        reload_app_module()


def test_missing_env_vars_raises_runtime_in_testing(monkeypatch):
    monkeypatch.setenv('FLASK_ENV', 'testing')
    monkeypatch.delenv('DB_PASSWORD', raising=False)
    monkeypatch.setenv('DB_HOST', 'localhost')
    monkeypatch.setenv('DB_NAME', 'aquahub_db')
    monkeypatch.setenv('DB_USER', 'postgres')
    monkeypatch.setenv('DB_PORT', '5432')
    with pytest.raises(RuntimeError):
        reload_app_module()


def test_env_vars_present_loads_app(monkeypatch):
    monkeypatch.setenv('FLASK_ENV', 'testing')
    monkeypatch.setenv('DB_HOST', 'localhost')
    monkeypatch.setenv('DB_NAME', 'aquahub_db')
    monkeypatch.setenv('DB_USER', 'postgres')
    monkeypatch.setenv('DB_PASSWORD', 'postgres')
    monkeypatch.setenv('DB_PORT', '5432')
    mod = reload_app_module()
    assert hasattr(mod, 'app')
