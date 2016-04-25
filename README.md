# Graylog Project Helper

Run the `scripts/bootstrap` script and import the graylog-project Maven project into your favorite IDE, we recommend IntelliJ IDEA.

Then create a server run configuration, but use the classpath of the module "runner".

This allows the listed plugins to be on the same classpath and thus loaded directly without having to go through mvn package and symlinking/copying into Graylog's plugins folder.

# Creating plugins

If you want to start developing a new plugin, use `scripts/bootstrap-plugin <plugin name>` to create one. The plugin name is also the directory/module name you will find the plugin after the script has been executed properly.

