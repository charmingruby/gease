package main

import (
	"context"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/gin-gonic/gin"
	"gitub.com/charmingruby/gease/internal/health"
	"gitub.com/charmingruby/gease/internal/shared/server"
	"gitub.com/charmingruby/gease/internal/signature"
)

func main() {
	r := gin.Default()

	health.NewHTTPHandler(r)
	signature.NewHTTPHandler(r)

	srv := server.New(r, "3001")

	go func() {
		if err := srv.Start(); err != nil {
			panic(err)
		}
	}()

	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	if err := srv.Shutdown(ctx); err != nil {
		panic(err)
	}
}
