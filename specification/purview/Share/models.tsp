import "@typespec/rest";
import "@typespec/http";
// import "@azure-tools/typespec-azure-core";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace Azure.Analytics.Purview.Share;

@doc("The type of share")
enum ShareKind {
  @doc("The type of share is in-place sharing")
  InPlace: "InPlace",
}

@doc("The type of share invitation")
enum InvitationKind {
  @doc("The invitation is sent to a user")
  User: "User",

  @doc("The invitation is sent to a service")
  Service: "Service",
}

@doc("The type of store")
enum StoreKind {
  @doc("The store kind is a Adls Gen 2 storage account")
  AdlsGen2Account: "AdlsGen2Account",

  @doc("The store kind is a Blob storage account")
  BlobAccount: "BlobAccount",
}

@doc("The type of reference")
enum ReferenceNameType {
  @doc("The type of reference is an ARM resource")
  ArmResourceReference: "ArmResourceReference",
}

@doc("The tenant email registration status")
enum TenantEmailRegistrationStatus {
  @doc("The tenant email registration is in pending state")
  ActivationPending: "ActivationPending",

  @doc("The tenant email registration is complete and has been activated")
  Activated: "Activated",

  @doc("The tenant email registration has exhausted the max attempts")
  ActivationAttemptsExhausted: "ActivationAttemptsExhausted",
}

@doc("The state of the resource")
enum State {
  @doc("The state of the resource is 'Unknown'")
  Unknown: "Unknown",

  @doc("The state of the resource is 'Succeeded'")
  Succeeded: "Succeeded",

  @doc("The state of the resource is 'Creating'")
  Creating: "Creating",

  @doc("The state of the resource is 'Deleting'")
  Deleting: "Deleting",

  @doc("The state of the resource is 'Moving'")
  Moving: "Moving",

  @doc("The state of the resource is 'Failed'")
  Failed: "Failed",
}

@doc("The status of the share")
enum ShareStatus {
  @doc("The share has not been accepted yet")
  Detached: "Detached",

  @doc("The share has been accepted by the recipient")
  Attached: "Attached",
}

@doc("A Store Reference for an artifact or sink.")
model StoreReference {
  @doc("Reference name for resource associated with the sink or artifact.")
  referenceName?: string;
}

/// Received Share

@doc("A received share.")
@resource("receivedShares")
@discriminator("shareKind")
model ReceivedShare {
  @doc("The unique id of the resource.")
  @visibility("read")
  @key("receivedShareId")
  id: string;
}

@doc("An InPlace received share kind.")
model InPlaceReceivedShare extends ReceivedShare {
  @doc("Defines the supported types for share.")
  shareKind: "InPlace";

  @doc("Location of the shared Asset.")
  @visibility("read")
  assetLocation?: string;

  @doc("The types of asset.")
  assetStoreKind?: StoreKind;

  @doc("Time at which the received share was created.")
  @visibility("read")
  createdAt?: utcDateTime;

  @doc("Received Share Name")
  displayName?: string;

  @doc("The expiration date of the received share.")
  @visibility("read")
  expirationDate?: utcDateTime;

  @doc("Email of the user/receiver who received the sent share invitation")
  @visibility("read")
  receiverEmail?: string;

  @doc("Name of the user/receiver who received the sent share invitation")
  @visibility("read")
  receiverName?: string;

  @doc("Tenant name of the user/receiver who received the sent share invitation")
  @visibility("read")
  receiverTenantName?: string;

  @doc("Email of the sender who created the sent share invitation")
  @visibility("read")
  senderEmail?: string;

  @doc("Name of the sender who created the sent share invitation")
  @visibility("read")
  senderName?: string;

  @doc("Tenant name of the sender who created the sent share invitation")
  @visibility("read")
  senderTenantName?: string;

  @doc("Share description.")
  @visibility("read")
  sentShareDescription?: string;

  @doc("Time at which the sent share was shared.")
  @visibility("read")
  sharedAt?: utcDateTime;

  @doc("Share status.")
  shareStatus?: ShareStatus;

  @doc("Holds details on the destination of the mapped artifact")
  sink?: Sink;

  @doc("State of the resource")
  @visibility("read")
  state?: State;
}

/// Sent Share

@doc("A sent share.")
@resource("sentShares")
@discriminator("shareKind")
model SentShare {
  @doc("The unique id of the resource.")
  @visibility("read")
  @key("sentShareId")
  id: string;
}

@doc("An InPlace sent share.")
model InPlaceSentShare extends SentShare {
  @doc("Defines the supported types for share.")
  shareKind: "InPlace";

  @doc("A class for sent share artifact.")
  artifact: Artifact;

  @doc("Time at which the sent share was created.")
  @visibility("read")
  createdAt?: utcDateTime;

  @doc("List of shares on which the sent share depends.")
  @visibility("read")
  dependsOn?: string[];

  @doc("Sent share description.")
  description?: string;

  @doc("The name of the sent share")
  displayName: string;

  @doc("Email of the sender who created the sent share.")
  @visibility("read")
  senderEmail?: string;

  @doc("Name of the sender who created the sent share.")
  @visibility("read")
  senderName?: string;

  @doc("Tenant name of the sender who created the sent share.")
  @visibility("read")
  senderTenantName?: string;

  @doc("State of the resource")
  @visibility("read")
  state?: State;
}

/// Sent Share Invitation

@doc("A sent share invitation.")
@discriminator("invitationKind")
@resource("sentShareInvitations")
@parentResource(SentShare)
model SentShareInvitation {
  @doc("The unique id of the resource.")
  @visibility("read")
  @key("sentShareInvitationId")
  id: string;
}

@doc("An service invitation.")
model ServiceInvitation extends SentShareInvitation {
  @doc("The invitation kind.")
  invitationKind: "Service";

  @doc("The time at which the invitation will expire.")
  expirationDate?: utcDateTime;

  @doc("Email address of the sender.")
  @visibility("read")
  senderEmail?: string;

  @doc("Name of the sender")
  @visibility("read")
  senderName?: string;

  @doc("Tenant name of the sender")
  @visibility("read")
  senderTenantName?: string;

  @doc("Gets the time at which the invitation was sent.")
  @visibility("read")
  sentAt?: utcDateTime;

  @doc("Share status.")
  shareStatus?: ShareStatus;

  @doc("State of the resource")
  @visibility("read")
  state?: State;

  @doc("The target azure active directory id the invitation is sent to.")
  targetActiveDirectoryId: string;

  @doc("The target object id in the azure active directory the invitation is sent to.")
  targetObjectId: string;
}

@doc("A user invitation kind.")
model UserInvitation extends SentShareInvitation {
  @doc("The invitation kind.")
  invitationKind: "User";

  @doc("The time at which the invitation will expire.")
  expirationDate?: utcDateTime;

  @doc("Whether or not the recipient was notified via email.")
  notify?: boolean;

  @doc("Email address of the sender.")
  @visibility("read")
  senderEmail?: string;

  @doc("Name of the sender")
  @visibility("read")
  senderName?: string;

  @doc("Tenant name of the sender")
  @visibility("read")
  senderTenantName?: string;

  @doc("Gets the time at which the invitation was sent.")
  @visibility("read")
  sentAt?: utcDateTime;

  @doc("Share status.")
  shareStatus?: ShareStatus;

  @doc("State of the resource")
  @visibility("read")
  state?: State;

  @doc("The receiver email for the invitation is being sent.")
  targetEmail: string;
}

/// Share Resource

@doc("A share resource.")
@resource("shareResources")
model ShareResource {
  @doc("The unique id of the resource.")
  @visibility("read")
  @key
  id: string;

  @doc("A count of Received Shares associated with the ShareResource.")
  receivedSharesCount?: int32;

  @doc("A count of Sent Shares associated with the ShareResource")
  sentSharesCount?: int32;

  @doc("The types of asset.")
  storeKind?: StoreKind;

  @doc("A Store Reference for an artifact or sink.")
  storeReference?: StoreReference;
}

/// Tenant Email Registration

@doc("A tenant email registration.")
@resource("emails")
model TenantEmailRegistration {
  @doc("The unique id of the TenantEmailRegistration.")
  @visibility("read")
  @key
  id: string;

  @doc("Activation code for the registration.")
  activationCode: string;

  @doc("Date of the activation expiration.")
  @visibility("read")
  activationExpiration?: utcDateTime;

  @doc("The email to register.")
  @visibility("read")
  email?: string;

  @doc("Defines the supported types for registration.")
  @visibility("read")
  registrationStatus?: TenantEmailRegistrationStatus;

  @doc("State of the resource")
  @visibility("read")
  state?: State;

  @doc("The tenant id to register.")
  @visibility("read")
  tenantId?: string;
}

/// Sink

@doc("Holds details on the destination of the mapped artifact")
@discriminator("storeKind")
model Sink {
  @doc("A Store Reference for an artifact or sink.")
  storeReference: StoreReference;
}

@doc("AdlsGen2 Sink")
model AdlsGen2AccountSink extends Sink {
  @doc("The storeKind for an AdlsGen2Account.")
  storeKind: "AdlsGen2Account";

  @doc("Adls Gen 2 Container Name")
  containerName: string;

  @doc("Adls Gen 2 Folder")
  folder: string;

  @doc("Adls Gen 2 Location")
  @visibility("read")
  location?: string;

  @doc("Adls Gen 2 Mount Path")
  mountPath?: string;
}

@doc("Blob Sink")
model BlobAccountSink extends Sink {
  @doc("The types of asset.")
  storeKind: "BlobAccount";

  @doc("Blob Container Name")
  containerName: string;

  @doc("Blob Folder")
  folder: string;

  @doc("Blob Location")
  @visibility("read")
  location?: string;

  @doc("Blob Mount Path")
  mountPath?: string;
}

/// Artifact

@doc("A class for sent share artifact.")
@discriminator("storeKind")
model Artifact {
  @doc("A Store Reference for an artifact or sink.")
  storeReference: StoreReference;
}

@doc("An Adls Gen2 storage account artifact.")
model AdlsGen2Artifact extends Artifact {
  @doc("The types of asset.")
  storeKind: "AdlsGen2Account";

  @doc("Location of the storage account.")
  @visibility("read")
  location?: string;

  @doc("A list of Adls Gen2 storage account paths.")
  paths: StorageAccountPath[];
}

@doc("Blob storage account artifact.")
model BlobStorageArtifact extends Artifact {
  @doc("The types of asset.")
  storeKind: "BlobAccount";

  @doc("Location of the storage account.")
  @visibility("read")
  location?: string;

  @doc("A list of blob storage account paths.")
  paths: StorageAccountPath[];
}

@doc("Defines a single StorageAccountPath path")
model StorageAccountPath {
  @doc("Gets or sets the container name")
  containerName: string;

  @doc("Gets or sets the path on the receiver side where the artifact is to be mapped")
  receiverPath?: string;

  @doc("Gets or sets the path to file/folder within the container to be shared")
  senderPath?: string;
}
