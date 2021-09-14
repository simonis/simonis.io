Jekyll::Hooks.register [:pages, :documents], :post_init do |doc|

  # get the last modified time of the page
  modification_time = ((::File.exists?(doc.path)) ? (::File.mtime doc.path) : ::Time.now)
  # $stdout.print "============ #{doc.path} ==== #{modification_time} ===\n"

  # inject modification_time in page's data
  doc.data['modified_date'] = modification_time
end

=begin

This is a small [Jekyll Hook](http://jekyllrb.com/docs/plugins/hooks/) for getting
the last modification time of a file based on:
https://stackoverflow.com/questions/36758072/how-to-insert-the-last-updated-time-stamp-in-jekyll-page-at-build-time

For `:pages` it looks like if I have to use `:post_init` instead of `:pre_render` as 
suggested in that post, otherwise the newly created page variable doesn't get propagated
to the final template .

Initially I tried to define a [page variable](http://jekyllrb.com/docs/variables/#page-variables)
with the help of AsciiDoctor's `docdate` [document attribute](https://docs.asciidoctor.org/asciidoc/latest/attributes/document-attributes-reference/) and [Jekyll-Asciidoc's page attributes](https://github.com/asciidoctor/jekyll-asciidoc#page-attributes):

```
= Hello world and welcome!
:page-author: Volker Simonis
:page-modified_date: {docdate}
```

Unfortunately this doesn't work, because Jekyll-Asciidoc calls `::Asciidoctor.load` in `converter.rb` without passing the `input_mtime` option which contains the last file modification time. Without this option, AsciiDoctor has no chance to get the modification time, because it does not have direct access to the file any more (instead, the file contents are passed as a string).

This could be fixed with the following patch:
```
/usr/gem/gems/jekyll-asciidoc-3.0.0/lib/jekyll-asciidoc/converter.rb
--- /usr/gem/gems/jekyll-asciidoc-3.0.0/lib/jekyll-asciidoc/converter.rb	2021-09-13 22:20:26.304838324 +0200
+++ /usr/gem/gems/jekyll-asciidoc-3.0.0/lib/jekyll-asciidoc/converter.rb	2021-09-13 22:15:46.024528690 +0200
@@ -187,6 +187,7 @@
             else
               paths.delete 'docdir'
             end
+            opts[:input_mtime] = ((::File.exists?(paths['docfile'])) ? (::File.mtime paths['docfile']) : ::Time.now)
             opts[:attributes] = opts[:attributes].merge paths
           end
           if (layout_attr = resolve_default_layout document, opts[:attributes])
```

=end
