package logger

import (
	"log/slog"
	"os"
)

var l *slog.Logger

func New() {
	l = slog.New(slog.NewJSONHandler(os.Stdout, nil))
	slog.SetDefault(l)
}

func Info(s string) {
	l.Info(s)
}

func Error(s string) {
	l.Error(s)
}

func Debug(s string) {
	l.Debug(s)
}

func Warn(s string) {
	l.Warn(s)
}
