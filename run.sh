docker run -d \
    --name "cloudflare-warp-proxy" \
    --cap-add NET_ADMIN \
    --sysctl net.ipv4.forward=1 \
    --env-file .env \
    -v $PWD/instance_data/etc:/user-etc \
    -v $PWD/instance_data/var/lib/cloudflare-warp:/mdm-data \
    cloudflare-warp-proxy-image