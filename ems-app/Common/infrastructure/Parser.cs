using System;

namespace ems_app.Common.infrastructure
{
    public static class Parser
    {
        public static T Parse<T>(object value)
        {
            Type type = typeof(T);
            string s = value != null ? value.ToString() : "";

            if (type == typeof(int) || type == typeof(int?))
            {
                int i;
                if (int.TryParse(s, out i))
                {
                    return (T)(object)i;
                }
                if (IsNullableType(type))
                {
                    return (T)(object)(null);
                }
                return (T)(object)(0);
            }

            if (type == typeof(double) || type == typeof(double?))
            {
                double d;
                if (double.TryParse(s, out d))
                {
                    return (T)(object)d;
                }
                if (IsNullableType(type))
                {
                    return (T)(object)(null);
                }
                return (T)(object)(0);
            }

            if (type == typeof(decimal) || type == typeof(decimal?))
            {
                decimal d;
                if (decimal.TryParse(s, out d))
                {
                    return (T)(object)d;
                }
                if (IsNullableType(type))
                {
                    return (T)(object)(null);
                }
                return (T)(object)(0);
            }

            if (type == typeof(DateTime) || type == typeof(DateTime?))
            {
                DateTime dt;
                if (DateTime.TryParse(s, out dt))
                {
                    return (T)(object)(dt);
                }
                if (IsNullableType(type))
                {
                    return (T)(object)(null);
                }
                return (T)(object)(DateTime.Parse("01/01/1900 00:00:00"));
            }

            throw new NotImplementedException("Type has not bee implemented");
        }

        private static bool IsNullableType(Type type)
        {
            if (type.IsGenericType && type.GetGenericTypeDefinition() == typeof(Nullable<>))
            {
                return true;
            }
            return false;
        }
    }
}