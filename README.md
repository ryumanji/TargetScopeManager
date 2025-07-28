# TargetScopeManager
Utility for managing penetration test targets by configuring $IP and $HOST environment variables for streamlined scope handling.

# Add the following to ~/.zshrc.
```
## Sync $IP/$HOST between tabs
precmd() {
  # Parse values from target.conf
  export TARGET_IP=$(grep '^IP:' $HOME/work/target_scope_manager/_conf/target.conf 2>/dev/null | awk '{print $2}')
  export TARGET_HOST=$(grep '^HOST:' $HOME/work/target_scope_manager/_conf/target.conf 2>/dev/null | awk '{print $2}')
}

## ALIASES
alias tsm='source $HOME/work/target_scope_manager/set_targets.sh && set_target'
```
# Usage
tsm -I <IP> -V <HOST>
