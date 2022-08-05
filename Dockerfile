FROM jekyll/jekyll:4.2.2
RUN /bin/bash && apt-get update && apt-get install -y nodejs