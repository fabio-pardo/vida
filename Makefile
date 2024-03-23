# Define SHELL variable to use zsh
APP := vida
SHELL := /bin/zsh

all:

be:
	. ~/.zshrc && workon ${APP} && uvicorn app.main:app --reload

flutter:
	flutter run
