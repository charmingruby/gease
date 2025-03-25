package config

import (
	"github.com/caarlos0/env/v6"
	"github.com/joho/godotenv"
	"gitub.com/charmingruby/gease/pkg/logger"
)

type environment struct {
	ServerPort    string `env:"SERVER_PORT" envDefault:"3000"`
	ApplicationID string `env:"APPLICATION_ID"`
}

func New() (Config, error) {
	if err := godotenv.Load(); err != nil {
		logger.Warn(".env file not found")
	}

	environment := environment{}
	if err := env.Parse(&environment); err != nil {
		return Config{}, err
	}

	return Config(environment), nil
}

type Config struct {
	ServerPort    string
	ApplicationID string
}
