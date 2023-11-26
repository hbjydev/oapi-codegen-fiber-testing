package main

import (
	"github.com/gofiber/fiber/v2"
	"github.com/hbjydev/api-testing/api"
)

type ServerInterface struct {}

func (s *ServerInterface) Healthcheck(c *fiber.Ctx) error {
  c.JSON(fiber.Map{"status": "ok"})
  return nil
}

func main() {
  e := fiber.New()

  api.RegisterHandlers(e, &ServerInterface{})

  if err := e.Listen(":8080"); err != nil {
    panic(err)
  }
}
