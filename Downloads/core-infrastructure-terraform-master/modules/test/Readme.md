# Testing modules

This folder holds tests for modules.

When creating a module it should have well defined inputs and outputs and should beable to be tested in isolation to the rest of the system.

A good example of this is the [concourse_ci module](../concourse_ci/Readme.md). It creates the dependent resources in the test then involkes the module. This means you can test this in your test aws account on your machine before you deploy it to your application environment in CI/CD.

Writing a test for any module you create is highly encouraged. Soon we will enforce testing if you have changed a module.

