package health

import (
	"fmt"

	"github.com/gin-gonic/gin"
)

func (e *endpoint) makeHealthCheck() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.JSON(200, gin.H{
			"status": fmt.Sprintf("%s is healthy", e.appID),
		})
	}
}
