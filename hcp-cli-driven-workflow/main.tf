terraform { 
  cloud { 
    
    organization = "ww-example-org" 

    workspaces { 
      name = "cli-driven-workflow" 
    } 
  } 
}

resource "time_sleep" "wait_10s" {
  create_duration = "10s"
}