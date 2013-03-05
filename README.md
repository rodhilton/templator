# Templator

Templator is an engine for processing templates with data files.  The templates and data files both use ERB to give users as much power and control over their templates as possible.  Data files are read using YAML format to ensure the readability of the data.

## Examples

If we create a file named template.txt.erb with the following contents:

```
Hello World!  It is <%= Time.now %>
```
then run Templator with:

```
./templator template.txt.erb
```

We see output similar to:

```
Hello World!  It is 2011-05-20 11:28:45 -0600
```

### Data Files

Here's a more complex example using a data file.  If we create a yaml file called data.yaml with the following contents:

```
company: Microbook

employees:
    - name: John
      title: Senior Monkey
    - name: Alice
      title: Widget Expert
```

And a template called payroll.txt.erb:

```
Payroll for <%= company %>:
<% employees.each do |employee| %>
    Paying <%= employee.name %>, a <%= employee.title %>
<% end %>
```

Then execute templator as follows:

```
./templator --data-files data.yaml payroll.txt.erb
```

You'd get back:

```
Payroll for Microbook:

    Paying John, a Senior Monkey

    Paying Alice, a Widget Expert
```

The ERB file can access any part of the yaml through basic object traversal.  Arrays work as well, so one could do "employees[1].name" or any obvious variation of the same.

You can also specify multiple data files by supplying a comma-delimited list, like so:

```
./templator --data-files data1.yaml,data2.yaml,important.yaml payroll.txt.erb
```

When duplicate data is found, later files take precedence over earlier ones.

### Flags

It is also possible to specify flags on the command line in order to tweak the template based on invocation.

For example, if we have a template, options.txt.erb:

```
The time is <% flags[:exact] ? Time.now : "now" %>
```

The ERB is accessing a hash called flags here, looking for a key called :exact.

If we run this as follows:

```
./templator options.txt.erb
```

We get back:

```
The time is now
```

But if we run with:

```
./templator -flag exact options.txt.erb
```

We get output more like:

```
The time is 2011-05-20 11:28:45 -0600
```

The -flag switch also supports setting flags to be specific values, such as "-f key:value" which could then be referenced in the ERB as "flags[:key]" which would return "value".

Additionally, this 'flags' hashmap is available for usage in the yaml file, which supports the same ERB syntax as the template files



