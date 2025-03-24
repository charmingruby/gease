package health

import "github.com/gin-gonic/gin"

type endpoint struct {
	router *gin.Engine
}

func newEndpoint(r *gin.Engine) *endpoint {
	return &endpoint{
		router: r,
	}
}

func (e *endpoint) Register() {
	api := e.router.Group("/api")

	api.GET("/health-check", e.makeHealthCheck())
}
