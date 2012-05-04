(defproject anagrams "1.0.0-SNAPSHOT"
  :jvm-opts ["-XX:GCTimeRatio=9"
             "-Xmx1g"]
  :description "Display anagrams of a phrase"
  :dependencies [[org.clojure/clojure "1.3.0"]
                 ]
  :main anagrams.core)
