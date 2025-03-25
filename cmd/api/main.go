package main

import (
	"context"
	"fmt"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/gin-gonic/gin"
	"gitub.com/charmingruby/gease/config"
	"gitub.com/charmingruby/gease/internal/health"
	"gitub.com/charmingruby/gease/internal/shared/server"
	"gitub.com/charmingruby/gease/pkg/logger"
)

func main() {
	logger.New()

	cfg, err := config.New()
	if err != nil {
		logger.Error(fmt.Sprintf("failed to load config: %v", err))
		os.Exit(1)
	}

	r := gin.Default()

	health.NewHTTPHandler(r, cfg.ApplicationID)

	srv := server.New(r, cfg.ServerPort)

	go func() {
		logger.Info(fmt.Sprintf("server started on port %s", cfg.ServerPort))

		if err := srv.Start(); err != nil {
			logger.Error(fmt.Sprintf("server start error: %v", err))
			os.Exit(1)
		}
	}()

	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit

	logger.Info("shutting down application")

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	logger.Info("shutting down server")
	if err := srv.Shutdown(ctx); err != nil {
		logger.Error(fmt.Sprintf("server shutdown error: %v", err))
		os.Exit(1)
	}
}
