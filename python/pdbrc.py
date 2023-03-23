"""
len -s /path/to/pdbrc.py ~/.pdbrc.py
"""
import pdb


class Config(pdb.DefaultConfig):
    sticky_by_default = True
    editor = "vim"
    truncate_long_lines = False

    def _set_aliases(self, pdb):
        # make 'l' an alias to 'longlist'
        Pdb = pdb.__class__
        Pdb.do_l = Pdb.do_longlist

    def setup(self, pdb):
        self._set_aliases(pdb)
