package signature

import "github.com/gin-gonic/gin"

func NewHTTPHandler(r *gin.Engine) {
	newEndpoint(r).Register()
}
