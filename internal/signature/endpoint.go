package signature

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

	api.POST("/signatures/sign", e.makeSign())
	api.GET("/signatures", e.makeRetrieveSignatures())
}
