FROM jekyll/jekyll:4.2.0

RUN gem install \
          asciidoctor:2.0.15 \
	  rouge:3.26.0 \
	  jekyll-asciidoc:3.0.0

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
