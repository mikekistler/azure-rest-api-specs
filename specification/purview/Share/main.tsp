import "@typespec/rest";
import "@typespec/http";
import "@typespec/versioning";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using TypeSpec.Versioning;

@versioned(APIVersion)
@useAuth(Purview.Share.Auth)
@service({
  title: "Purview Share"
})
@server(
  "{endpoint}",
  "Creates a data plane client for Purview Share.",
  {
    endpoint: string,
  }
)
@doc("Creates a data plane client for Purview Share.")
namespace Azure.Analytics.Purview.Share;

@doc("Azure Active Directory OAuth2 Flow.")
model Auth is OAuth2Auth<[
  {
    type: OAuth2FlowType.implicit,
    authorizationUrl: "https://login.microsoftonline.com/common/oauth2/authorize",
    scopes: ["https://purview.azure.net/.default"],
  }
]>;

@doc("Purview Share API Versions.")
enum APIVersion {
  @doc("2023-08-01-preview")
  @useDependency(Azure.Core.Versions.v1_0_Preview_2)
  v2023_08_01_preview: "2023-08-01-preview",
}
