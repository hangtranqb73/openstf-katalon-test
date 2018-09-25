package main

import(
  "fmt"
  "io"
  "os"
  "net"
  "strconv"
  "io/ioutil"
  "os/exec"
  "encoding/json"
  "net/http"
)

type Config struct {
  DestIP net.IP
  DestPort uint
}

func parseConfig() (*Config, error) {
  const DEST_IP = "DEST_IP"
  ipStr := os.Getenv(DEST_IP)
  ip := net.ParseIP(ipStr)
  if ip == nil {
    errMsg := fmt.Errorf("%v is invalid: %v\n", DEST_IP, ipStr)
    return nil, errMsg
  }

  const DEST_PORT = "DEST_PORT"
  portStr := os.Getenv(DEST_PORT)
  port, err := strconv.ParseUint(portStr, 10, 32)
  if err != nil {
    errMsg := fmt.Errorf("%v is invalid: %v\n", DEST_PORT, portStr)
    return nil, errMsg
  }

  return &Config {
    DestIP: ip,
    DestPort: uint(port),
  }, nil
}

var processMap map[uint]*os.Process
var config *Config

func main() {
  var err error
  config, err = parseConfig()
  if err != nil {
    fmt.Fprintf(os.Stderr, err.Error())
    os.Exit(1)
  }

  processMap = make(map[uint]*os.Process)

  http.HandleFunc("/clear", clearHandler)
  http.HandleFunc("/portforward", handler)
  http.ListenAndServe(":80", nil)
}

func startPortFowarding(port uint) error {
  if _, exists := processMap[port]; exists {
    msg := "Already executing port forwarding. port: %v\n"
    return fmt.Errorf(msg, port)
  }

  cmd := exec.Command("ssh", makeCommandArgs(*config, port)...)
  exec.Command("ssh", makeCommandArgs(*config, port)...)
  err := cmd.Start()
  processMap[port] = cmd.Process
  if err != nil {
    return fmt.Errorf("SSH couldn't execute")
  }
  fmt.Printf("Port forwarding started\n")
  fmt.Printf("%v\n", processMap)

  return nil
}

func stopPortFowarding(port uint) error {
  if _, exists := processMap[port]; !exists {
    msg := "Have not port forwarded. port: %v\n"
    return fmt.Errorf(msg, port)
  }

  processMap[port].Kill()
  delete(processMap, port)
  fmt.Printf("Port forwarding stopped\n")
  fmt.Printf("%v\n", processMap)

  return nil
}

func handler(w http.ResponseWriter, r *http.Request) {
  isPost := r.Method == http.MethodPost
  isDelete := r.Method == http.MethodDelete

  if !(isPost || isDelete) {
    w.WriteHeader(http.StatusMethodNotAllowed)
    return
  }

  param := parseRequest(r)
  fmt.Printf("Request parsed\n", param)
  fmt.Printf("params: %v\n", param)
  if param == nil {
    w.WriteHeader(http.StatusBadRequest)
    return
  }
  port := uint(param["port"].(float64))

  var err error
  if isPost {
    err = startPortFowarding(port)
  } else if isDelete {
    err = stopPortFowarding(port)
  }

  if err != nil {
    w.WriteHeader(http.StatusInternalServerError)
    io.WriteString(w, err.Error())
    return
  }

  w.WriteHeader(http.StatusOK)
}

func clearHandler(w http.ResponseWriter, r *http.Request) {
  for _, process := range processMap {
    process.Kill()
  }
  fmt.Printf("*clear\n")
  processMap = make(map[uint]*os.Process)

  w.WriteHeader(http.StatusOK)
}

func parseRequest(r *http.Request) map[string]interface{} {
  body, err := ioutil.ReadAll(r.Body)
  defer r.Body.Close()
  if err != nil { return nil }

  var jsonBody map[string]interface{}
  err = json.Unmarshal(body, &jsonBody)
  if err != nil { return nil }

  return jsonBody
}

func makeCommandArgs(config Config, port uint) []string {
  return []string{
    "-o", "StrictHostKeyChecking=no",
    "-o", "UserKnownHostsFile=/dev/null",
    "-gNL", fmt.Sprintf("%v:stf:%v", port, port),
    "-i", "/root/.ssh/id.key", "-p", fmt.Sprintf("%v", config.DestPort),
    fmt.Sprintf("ssh@%v", config.DestIP),
  }
}

