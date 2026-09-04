using Aspire.Hosting.PolyStack;

var builder = DistributedApplication.CreateBuilder(args);

builder = builder.AsPolyStackDistributedApplicationBuilder();

// -----------------------------------------------------------------------------
// PolyStack DevKit (nuget.org: PolyStack.Aspire.Hosting.Demo / SchemaExtraction)
// Docs: https://github.com/getpolystack/devkit/tree/main/docs
//
// 1) Wrap the Aspire builder with the DevKit facade (same method names as the
//    private Multicloud kit — swap packages later without rewriting AppHost):
//
//      builder = builder.AsPolyStackDistributedApplicationBuilder();
//
// 2) Register modules once you have Presentation + ApplicationBuilder types:
//
//      poly.AddPolyStackModule<MyPresentation, MyApplicationBuilder>("my-api");
//
// 3) Optional: declare logical sync edges / externals (Docker, Vite, Python):
//
//      poly.AddSynchronousModuleCall("Frontend", "MyModule");
//      // resource.AsExternalPolyStackModule(poly, "Scanner", StackModuleSource.Python);
//
// 4) Build through the facade so DevKit writes *.polystack-scheme.json under
//    .polystack/ and starts the schema UI on http://localhost:18889/
//
//      builder.Build().Run();
//      return;
//
// Until you add modules, this blank AppHost still runs the facade + schema UI
// with an empty catalog (expected).
// -----------------------------------------------------------------------------





builder.Build().Run();
