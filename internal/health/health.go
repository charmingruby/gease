package health

import "github.com/gin-gonic/gin"

func NewHTTPHandler(r *gin.Engine, appID string) {
	newEndpoint(r, appID).Register()
}
