FROM haskell:7.10
 
RUN cabal update
 
 
# Add .cabal file
ADD ./BookCRDHsk.cabal /opt/server/BookCRDHsk.cabal
 
 
# Docker will cache this command as a layer, freeing us up to
# modify source code without re-installing dependencies
# RUN cd /opt/server && cabal install --only-dependencies -j4
 
 
# Add and Install Application Code
ADD ./app /opt/server/app
RUN cd /opt/server && cabal install
 
 
# Add installed cabal executables to PATH
ENV PATH /root/.cabal/bin:$PATH
 
 
# Default Command for Container
WORKDIR /opt/server
EXPOSE 8030
CMD ["cabal run"]