AddPackage noise-suppression-for-voice

cat > "$(CreateFile /etc/pipewire/input-filter-chain.conf)" << EOF
# Noise canceling source
#
# start with pipewire -c filter-chain/input-filter-chain.conf
#
context.properties = {
    log.level        = 0
}

context.spa-libs = {
    audio.convert.* = audioconvert/libspa-audioconvert
    support.*       = support/libspa-support
}

context.modules = [
    {   name = libpipewire-module-rtkit
        args = {
            #nice.level   = -11
            #rt.prio      = 88
            #rt.time.soft = 200000
            #rt.time.hard = 200000
        }
        flags = [ ifexists nofail ]
    }
    {   name = libpipewire-module-protocol-native }
    {   name = libpipewire-module-client-node }
    {   name = libpipewire-module-adapter }

    {   name = libpipewire-module-filter-chain
        args = {
            node.name =  "rnnoise_source"
            node.description =  "Noise Canceling source"
            media.name =  "Noise Canceling source"
            filter.graph = {
                nodes = [
                    {
                        type = ladspa
                        name = rnnoise
                        plugin = /usr/lib/ladspa/librnnoise_ladspa.so
                        label = noise_suppressor_stereo
                        control = {
                            "VAD Threshold (%)" 50.0
                        }
                    }
                ]
            }
            capture.props = {
                node.passive = true
            }
            playback.props = {
                media.class = Audio/Source
            }
        }
    }
]
EOF

cat > "$(CreateFile /etc/systemd/user/pipewire-input-filter-chain.service)" << EOF
[Unit]
Description=PipeWire Input Filter Chain
After=pipewire.service
BindsTo=pipewire.service

[Service]
ExecStart=/usr/bin/pipewire -c /etc/pipewire/input-filter-chain.conf
Type=simple
Restart=on-failure

[Install]
WantedBy=pipewire.service
EOF
