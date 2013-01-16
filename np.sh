#!/bin/bash
xvkbd -xsendevent -text "np: $(mpc current | recode u8..l1)" 2>/dev/null
