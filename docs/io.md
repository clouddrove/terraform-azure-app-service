## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| acr\_id | Container registry id to give access to pull images | `string` | `null` | no |
| app\_service\_environment\_id | The ID of the App Service Environment to create this Service Plan in. Requires an Isolated SKU. Use one of I1, I2, I3 for azurerm\_app\_service\_environment, or I1v2, I2v2, I3v2 for azurerm\_app\_service\_environment\_v3 | `string` | `null` | no |
| app\_service\_logs | Configuration of the App Service and App Service Slot logs. Documentation [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app#logs) | <pre>object({<br>    detailed_error_messages = optional(bool)<br>    failed_request_tracing  = optional(bool)<br>    application_logs = optional(object({<br>      file_system_level = string<br>      azure_blob_storage = optional(object({<br>        level             = string<br>        retention_in_days = number<br>        sas_url           = string<br>      }))<br>    }))<br>    http_logs = optional(object({<br>      azure_blob_storage = optional(object({<br>        retention_in_days = number<br>        sas_url           = string<br>      }))<br>      file_system = optional(object({<br>        retention_in_days = number<br>        retention_in_mb   = number<br>      }))<br>    }))<br>  })</pre> | `null` | no |
| app\_service\_vnet\_integration\_subnet\_id | Id of the subnet to associate with the app service | `string` | `null` | no |
| app\_settings | Application settings for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#app_settings | `map(string)` | `{}` | no |
| application\_insights\_enabled | Use Application Insights for this App Service | `bool` | `true` | no |
| application\_insights\_id | ID of the existing Application Insights to use instead of deploying a new one. | `string` | `null` | no |
| application\_insights\_sampling\_percentage | Specifies the percentage of sampled datas for Application Insights. Documentation [here](https://docs.microsoft.com/en-us/azure/azure-monitor/app/sampling#ingestion-sampling) | `number` | `null` | no |
| application\_insights\_type | Application type for Application Insights resource | `string` | `"web"` | no |
| auth\_settings | Authentication settings. Issuer URL is generated thanks to the tenant ID. For active\_directory block, the allowed\_audiences list is filled with a value generated with the name of the App Service. See https://www.terraform.io/docs/providers/azurerm/r/app_service.html#auth_settings | `any` | `{}` | no |
| auth\_settings\_v2 | Authentication settings V2. See https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app#auth_settings_v2 | `any` | `{}` | no |
| authorized\_ips | IPs restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#ip_restriction | `list(string)` | `[]` | no |
| authorized\_service\_tags | Service Tags restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#ip_restriction | `list(string)` | `[]` | no |
| authorized\_subnet\_ids | Subnets restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#ip_restriction | `list(string)` | `[]` | no |
| client\_affinity\_enabled | Client affinity activation for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#client_affinity_enabled | `bool` | `false` | no |
| connection\_strings | Connection strings for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#connection_string | `list(map(string))` | `[]` | no |
| current\_stack | Specify runtime stack here | `string` | `null` | no |
| disable\_ip\_masking | By default the real client ip is masked as `0.0.0.0` in the logs. Use this argument to disable masking and log the real client ip | `bool` | `false` | no |
| docker\_image\_name | The docker image, including tag, to be used. e.g. appsvc/staticsite:latest. | `string` | `""` | no |
| docker\_registry\_password | The User Name to use for authentication against the registry to pull the image. | `string` | `null` | no |
| docker\_registry\_url | The URL of the container registry where the docker\_image\_name is located. e.g. https://index.docker.io or https://mcr.microsoft.com. This value is required with docker\_image\_name | `string` | `""` | no |
| docker\_registry\_username | The User Name to use for authentication against the registry to pull the image. | `string` | `null` | no |
| dotnet\_core\_version | dotnet version | `string` | `null` | no |
| dotnet\_version | dotnet version | `string` | `null` | no |
| enable | Set to false to prevent the module from creating any resources. | `bool` | `true` | no |
| enable\_private\_endpoint | enable or disable private endpoint to storage account | `bool` | `false` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| existing\_private\_dns\_zone | Name of the existing private DNS zone | `string` | `null` | no |
| existing\_private\_dns\_zone\_resource\_group\_name | The name of the existing resource group | `string` | `""` | no |
| extra\_tags | Variable to pass extra tags. | `map(string)` | `null` | no |
| go\_version | Go version | `string` | `null` | no |
| https\_only | HTTPS restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#https_only | `bool` | `false` | no |
| identity | Map with identity block information. | <pre>object({<br>    type         = string<br>    identity_ids = list(string)<br>  })</pre> | <pre>{<br>  "identity_ids": [],<br>  "type": "SystemAssigned"<br>}</pre> | no |
| instance\_count | The number of instance count for resources | `number` | `1` | no |
| ip\_restriction\_headers | IPs restriction headers for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#headers | `map(list(string))` | `null` | no |
| java\_embedded\_server\_enabled | Java server | `string` | `null` | no |
| java\_server | Java server | `string` | `null` | no |
| java\_server\_version | Java server version | `string` | `null` | no |
| java\_version | Java version | `string` | `null` | no |
| label\_order | Label order, e.g. sequence of application name and environment `name`,`environment`,'attribute' [`webserver`,`qa`,`devops`,`public`,] . | `list(any)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| location | Location where resource group will be created. | `string` | `null` | no |
| log\_analytics\_workspace\_id | Log Analytics workspace id in which logs should be retained. | `string` | `null` | no |
| managedby | ManagedBy, eg ''. | `string` | `""` | no |
| maximum\_elastic\_worker\_count | The maximum number of workers to use in an Elastic SKU Plan. Cannot be set unless using an Elastic SKU. | `number` | `null` | no |
| mount\_points | Storage Account mount points. Name is generated if not set and default type is AzureFiles. See https://www.terraform.io/docs/providers/azurerm/r/app_service.html#storage_account | `list(map(string))` | `[]` | no |
| name | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| node\_version | Node version | `string` | `null` | no |
| os\_type | The O/S type for the App Services to be hosted in this plan. Possible values include `Windows`, `Linux`, and `WindowsContainer`. | `string` | n/a | yes |
| per\_site\_scaling\_enabled | Should Per Site Scaling be enabled. | `bool` | `false` | no |
| php\_version | php version | `string` | `null` | no |
| private\_endpoint\_subnet\_id | Subnet ID for private endpoint | `string` | `null` | no |
| public\_network\_access\_enabled | Whether enable public access for the App Service. | `bool` | `true` | no |
| python\_version | Python version | `string` | `null` | no |
| read\_permissions | Read permissions for telemetry | `list(string)` | <pre>[<br>  "aggregate",<br>  "api",<br>  "draft",<br>  "extendqueries",<br>  "search"<br>]</pre> | no |
| repository | Terraform current module repo | `string` | `""` | no |
| resource\_group\_name | A container that holds related resources for an Azure solution | `string` | `""` | no |
| retention\_in\_days | Specifies the retention period in days. Possible values are `30`, `60`, `90`, `120`, `180`, `270`, `365`, `550` or `730` | `number` | `90` | no |
| ruby\_version | Ruby version | `string` | `null` | no |
| scm\_authorized\_ips | SCM IPs restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#scm_ip_restriction | `list(string)` | `[]` | no |
| scm\_authorized\_service\_tags | SCM Service Tags restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#scm_ip_restriction | `list(string)` | `[]` | no |
| scm\_authorized\_subnet\_ids | SCM subnets restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#scm_ip_restriction | `list(string)` | `[]` | no |
| scm\_ip\_restriction\_headers | IPs restriction headers for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#headers | `map(list(string))` | `null` | no |
| site\_config | Site config for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#site_config. IP restriction attribute is no more managed in this block. | `any` | `{}` | no |
| sku\_name | The SKU for the plan. Possible values include B1, B2, B3, D1, F1, FREE, I1, I2, I3, I1v2, I2v2, I3v2, P1v2, P2v2, P3v2, P1v3, P2v3, P3v3, S1, S2, S3, SHARED, Y1, EP1, EP2, EP3, WS1, WS2, and WS3. | `string` | n/a | yes |
| staging\_slot\_custom\_app\_settings | Override staging slot with custom app settings | `map(string)` | `null` | no |
| tomcat\_version | tomcat version | `string` | `null` | no |
| use\_current\_stack | Variable for current stack for windows web app ( Possible values -> dotnet, dotnetcore, node, python, php, and java ) | `bool` | `true` | no |
| use\_docker | Variable to use container as runtime | `bool` | `false` | no |
| use\_dotnet | Variable to use dotnet as runtime | `bool` | `false` | no |
| use\_go | Variable to use GO as runtime | `bool` | `false` | no |
| use\_java | Variable to use java as runtime | `bool` | `false` | no |
| use\_node | Variable to use node as runtime | `bool` | `false` | no |
| use\_php | Variable to use php as runtime | `bool` | `false` | no |
| use\_python | Variable to use python as runtime | `bool` | `false` | no |
| use\_ruby | Variable to use ruby as runtime | `bool` | `false` | no |
| use\_tomcat | Variable to use tomcat as runtime | `bool` | `false` | no |
| virtual\_network\_id | The name of the virtual network | `string` | `null` | no |
| worker\_count | The number of Workers (instances) to be allocated. | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| app\_service\_default\_site\_hostname | The Default Hostname associated with the App Service |
| app\_service\_id | Id of the App Service |
| app\_service\_name | Name of the App Service |
| app\_service\_outbound\_ip\_addresses | Outbound IP adresses of the App Service |
| app\_service\_possible\_outbound\_ip\_addresses | Possible outbound IP adresses of the App Service |
| app\_service\_site\_credential | Site credential block of the App Service |
| connection\_string | n/a |
| instrumentation\_key | n/a |
| service\_plan\_id | The ID of the App Service Plan component. |
| service\_plan\_location | Azure location of the created Service Plan |
| service\_plan\_name | The Name of the App Service Plan component. |

