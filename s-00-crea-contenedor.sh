docker run -i -t \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-v ${UNAM_HOME}:${UNAM_HOME} \
--name c-dtc-proy-final \
--hostname h-dtc-proy-final \
--network bda_network --ip 172.22.0.11 \
--expose 1521 \
--shm-size=2gb \
-e DISPLAY=$DISPLAY ol-dtc:1.0 bash



docker run -i -t \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-v /unam:/unam \
--name c-dtc-proy-final \
--hostname h-dtc-proy-final \
--network bda_network --ip 172.22.0.11 \
--expose 1521 \
--shm-size=2gb \
-e DISPLAY=$DISPLAY oradb-unam-proyecto:1.0 bash
