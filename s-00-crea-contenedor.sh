#docker network create --subnet=172.22.0.0/16 bda_network       --Esto ejecutalo si no lo tienes creado
docker run -i -t \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-v ${UNAM_HOME}:${UNAM_HOME} \
--name c-ens-proy-final \ #Aqui cambia tus iniciales Erick
--hostname h-ens-proy-final \ #Aqui cambia tus iniciales Erick
--network bda_network --ip 172.22.0.11 \
--expose 1521 \
--shm-size=2gb \
-e DISPLAY=$DISPLAY ol-dtc:1.0 bash
