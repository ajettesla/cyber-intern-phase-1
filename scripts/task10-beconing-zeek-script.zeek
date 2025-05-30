module BeaconInterval;

# First redefine the enum, before anything else
redef enum Notice::Type += {
    Beaconing_Fixed_Interval
};

# Now declare global variables
global conn_times: table[addr] of table[addr] of vector of time;

const interval_tolerance: interval = 5secs;
const min_connections: count = 5;

event connection_state_remove(c: connection) {
    local orig: addr = c$id$orig_h;
    local resp: addr = c$id$resp_h;
    local now: time = network_time();

    if (orig !in conn_times) {
        conn_times[orig] = table();
    }
    if (resp !in conn_times[orig]) {
        conn_times[orig][resp] = vector();
    }

    conn_times[orig][resp] += now;

    local times: vector of time = conn_times[orig][resp];

    if (|times| >= min_connections) {
        local consistent: bool = T;
        local expected_interval: interval = times[1] - times[0];

        local i: count = 1;
        while (i <= |times| - 2) {
            local delta: interval = times[i + 1] - times[i];
            if (delta < expected_interval - interval_tolerance || delta > expected_interval + interval_tolerance) {
                consistent = F;
                break;
            }
            i += 1;
        }

        if (consistent) {
            NOTICE([
                $note=Beaconing_Fixed_Interval,
                $msg=fmt("Possible beaconing from %s to %s at ~%.2f second intervals",
                         orig, resp, interval_to_double(expected_interval)),
                $conn=c
            ]);
            conn_times[orig][resp] = vector();
        }
    }
}
