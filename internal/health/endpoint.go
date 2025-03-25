package health

import "github.com/gin-gonic/gin"

type endpoint struct {
	router *gin.Engine
	appID  string
}

func newEndpoint(r *gin.Engine, appID string) *endpoint {
	return &endpoint{
		router: r,
		appID:  appID,
	}
}

func (e *endpoint) Register() {
	api := e.router.Group("/api")

	api.GET("/health-check", e.makeHealthCheck())
}
