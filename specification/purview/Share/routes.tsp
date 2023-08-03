import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

//using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.Core;
using Azure.Core.Traits;

namespace Azure.Analytics.Purview.Share;

alias ServiceTraits = SupportsRepeatableRequests &
  NoConditionalRequests &
  NoClientRequestId;

alias Operations = Azure.Core.ResourceOperations<ServiceTraits>;

 /**
 * Operation that lists resources in a paginated way. Allows custom route and parameters.
 * @template TResource The type of the resource.
 * @template TParams Object describing the request parameters of the operation.
 */
 @get
 op CustomResourceList<
   TResource extends TypeSpec.Reflection.Model,
   TParams extends TypeSpec.Reflection.Model> is
   Foundations.Operation<
    Foundations.CollectionKeysOf<TResource> & TParams,
    Foundations.CustomPage<TResource>,
    ServiceTraits>;

@tag("ReceivedShare")
interface ReceivedShares {
  @summary("Get a received share by unique id.")
  @doc("Get a received share")
  get is Operations.ResourceRead<ReceivedShare>;

  @summary("Create or replace a received share.")
  @doc("Update changes to a received share")
  createOrReplace is Operations.ResourceCreateOrReplace<ReceivedShare>;

  @summary("Deletes a received share")
  @doc("Delete a received share")
  @pollingOperation(ReceivedShares.getStatus)
  delete is Operations.LongRunningResourceDelete<ReceivedShare>;

  @summary("Get a list of attached received shares.")
  @doc("List attached received shares")
  @route("/receivedShares/attached")
  #suppress "@azure-tools/typespec-azure-core/use-standard-operations" "list template does not support extra path segment"
  #suppress "@azure-tools/typespec-azure-core/no-explicit-routes-resource-ops" "Need to add final path segment"
  listAttached is CustomResourceList<ReceivedShare,
    {
      @doc("A name that references a data store.")
      @query
      referenceName: string;

      ...FilterQueryParameter;
      ...OrderByQueryParameter;
    }
  >;

  @summary("List detached received shares")
  @doc("Get a list of detached received shares.")
  @route("/receivedShares/detached")
  #suppress "@azure-tools/typespec-azure-core/use-standard-operations" "list template does not support extra path segment"
  #suppress "@azure-tools/typespec-azure-core/no-explicit-routes-resource-ops" "Need to add final path segment"
  listDetached is CustomResourceList<ReceivedShare,
    {
      ...FilterQueryParameter;
      ...OrderByQueryParameter;
    }
  >;

  @summary("Get received share operation status.")
  @doc("Gets status of a ReceivedShare operation.")
  getStatus is Operations.GetResourceOperationStatus<ReceivedShare>;
}

@tag("SentShare")
interface SentShares {
  @summary("Get a list of sent shares.")
  @doc("List sent shares")
  @route("/sentShares")
  #suppress "@azure-tools/typespec-azure-core/use-standard-operations" "list template does not support extra path segment"
  #suppress "@azure-tools/typespec-azure-core/no-explicit-routes-resource-ops" "Need to add final path segment"
  list is CustomResourceList<SentShare,
  {
    @doc("A name that references a data store.")
    @query
    referenceName: string;

    ...FilterQueryParameter;
    ...OrderByQueryParameter;
  }
  >;

  @summary("Get a sent share by guid.")
  @doc("Get a sent share")
  get is Operations.ResourceRead<SentShare>;

  @summary("Create or replace a sent share.")
  @doc("Create or replace a sent share")
  createOrReplace is Operations.ResourceCreateOrReplace<SentShare>;

  @summary("Deletes a sent share")
  @doc("Delete a sent share")
  @pollingOperation(SentShares.getStatus)
  delete is Operations.LongRunningResourceDelete<SentShare>;

  @summary("Get sent share operation status.")
  @doc("Gets status of a SentShare operation.")
  getStatus is Operations.GetResourceOperationStatus<SentShare>;
}

@tag("SentShareInvitation")
interface SentShareInvitations {
  @summary("List all sent share invitations in a sent share")
  @doc("List sent share recipients")
  @route("/sentShares/{sentShareId}/sentShareInvitations")
  #suppress "@azure-tools/typespec-azure-core/use-standard-operations" "list template does not support extra path segment"
  #suppress "@azure-tools/typespec-azure-core/no-explicit-routes-resource-ops" "Need to add final path segment"
  listInvitations is CustomResourceList<SentShareInvitation,
    {
      ...FilterQueryParameter;
      ...OrderByQueryParameter;
    }
  >;

  @summary("Get sent share invitation")
  @doc("Get an invitation for a sent share")
  @get
  getInvitation is Operations.ResourceRead<SentShareInvitation>;
  
  @summary("Create a sent share invitation.")
  @doc("Create a recipient for a given sent share")
  createOrReplaceInvitation is Operations.ResourceCreateOrReplace<SentShareInvitation>;

  @summary("Delete Invitation in a share.")
  @doc("Delete a sent share invitation")
  @pollingOperation(SentShareInvitations.getStatus)
  deleteInvitation is Operations.LongRunningResourceDelete<SentShareInvitation>;

  @summary("Notifies the recipient of the sent share invitation.")
  @doc("Notifies the user recipient of the sent share invitation, does not apply to service invitations.")
  notify is Operations.ResourceAction<SentShareInvitation, {}, SentShareInvitation>;

  @summary("Get sent share invitation operation status.")
  @doc("Gets status of a SentShareInvitation operation.")
  getStatus is Operations.GetResourceOperationStatus<SentShareInvitation>;
}

@tag("ShareResource")
interface ShareResources {
  @summary("API operation to list ShareResources.")
  @doc("List share resources")
  list is Operations.ResourceList<ShareResource,
    ListQueryParametersTrait<{
      ...FilterQueryParameter;
      ...OrderByQueryParameter;
    }>>;
}

@tag("TenantEmailRegistration")
interface TenantEmailRegistrations {
  @summary("Activates the tenant and email combination using the activation code received.")
  @doc("Activates the email registration for current tenant")
  activate is Operations.ResourceCollectionAction<TenantEmailRegistration,
    {
      @doc("The tenant email registration payload")
      @body
      tenantEmailRegistration: TenantEmailRegistration;
    },
    TenantEmailRegistration
  >;

  @summary("Registers the tenant and email combination for activation.")
  @doc("Register an email for the current tenant")
  register is Operations.ResourceCollectionAction<TenantEmailRegistration,
    {},
    TenantEmailRegistration
  >;
}
